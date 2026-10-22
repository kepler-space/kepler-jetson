#
# Runtime tests for the ECG software, run with testimage on the emulated ECG
# (kepler-ecg-qemu).
#

from oeqa.runtime.case import OERuntimeTestCase
from oeqa.core.decorator.depends import OETestDepends
from oeqa.runtime.decorator.package import OEHasPackage


class KeplerEcgTest(OERuntimeTestCase):

    def run_ok(self, cmd):
        status, output = self.target.run(cmd)
        self.assertEqual(status, 0, msg="'%s' failed:\n%s" % (cmd, output))
        return output


class KeplerEcgNetworkTest(KeplerEcgTest):

    @OETestDepends(['ssh.SSHTest.test_ssh'])
    @OEHasPackage(['kepler-ecg-ip-config'])
    def test_ip_config(self):
        self.run_ok('systemctl is-active kepler-ecg-ip-config.service')
        # No blade ID is simulated by default, so the fallback address is used
        output = self.run_ok('ip -4 addr show dev eth0')
        self.assertIn('192.168.109.1/24', output, msg=output)
        self.assertEqual(self.run_ok('hostname').strip(), 'ecg0')
        output = self.run_ok('cat /etc/hosts')
        self.assertIn('192.168.109.10 kepler-mpcu.local', output, msg=output)

    @OETestDepends(['ssh.SSHTest.test_ssh'])
    @OEHasPackage(['kepler-ecg-qemu-blade-id'])
    def test_blade_id_gpios(self):
        self.run_ok('systemctl is-active kepler-ecg-qemu-blade-id.service')
        output = self.run_ok('. /run/kepler/blade-id.env && '
                             'gpioget -c "${BLADE_ID_CHIP}" --numeric 109 127 98 104 96')
        self.assertEqual(output.split(), ['0'] * 5, msg=output)


class KeplerEcgPeripheralTest(KeplerEcgTest):

    @OETestDepends(['ssh.SSHTest.test_ssh'])
    @OEHasPackage(['kepler-ecg-qemu-obc-uart'])
    def test_obc_uart_login(self):
        self.run_ok('systemctl is-active serial-getty@ttyS0.service')

    @OETestDepends(['ssh.SSHTest.test_ssh'])
    @OEHasPackage(['chrony'])
    def test_pps_refclock(self):
        self.run_ok('test -c /dev/pps0')
        self.run_ok('systemctl is-active chronyd.service')
        output = self.run_ok('chronyc -n sources')
        self.assertIn('PPS0', output, msg=output)

    @OETestDepends(['ssh.SSHTest.test_ssh'])
    @OEHasPackage(['kepler-ssd-format'])
    def test_ssd_format_and_mount(self):
        self.run_ok('test -b /dev/ssd1')
        # The SSD image persists between runs, and is mounted at boot once formatted
        self.run_ok('systemctl stop mnt-persistent.mount')
        self.run_ok('kepler-ssd-format ssd1')
        self.run_ok('test -b /dev/ssd1p1')
        # systemd mounts the fstab entry once the partition appears
        self.run_ok('systemctl start mnt-persistent.mount')
        output = self.run_ok('grep " /mnt/persistent " /proc/mounts')
        self.assertIn(' ext4 ', output, msg=output)
        self.run_ok('touch /mnt/persistent/kepler-test && rm /mnt/persistent/kepler-test')


class KeplerEcgDockerTest(KeplerEcgTest):

    @OETestDepends(['ssh.SSHTest.test_ssh'])
    @OEHasPackage(['docker', 'docker-moby'])
    def test_docker_daemon(self):
        self.run_ok('systemctl start docker.service')
        output = self.run_ok('docker info --format "{{.ServerVersion}}"')
        self.assertTrue(output.strip(), msg=output)
