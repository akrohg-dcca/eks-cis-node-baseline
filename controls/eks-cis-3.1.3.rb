control 'eks-cis-3.1.3' do
  title "Ensure that the kubelet configuration file has permissions set to
  644 or more restrictive"
  desc  "Ensure that if the kubelet refers to a configuration file with the
`--config` argument, that file has permissions of 644 or more restrictive."
  desc  'rationale', "The kubelet reads various parameters, including security
settings, from a config file specified by the `--config` argument. If this file
is specified you should restrict its file permissions to maintain the integrity
of the file. The file should be writable by only the administrators on the
system."
  desc  'check', "
    First, SSH to the relevant worker node:

    To check to see if the Kubelet Service is running:
    ```
    sudo systemctl status kubelet
    ```
    The output should return `Active: active (running) since..`

    Run the following command on each node to find the appropriate Kubelet
config file:

    ```
    ps -ef | grep kubelet
    ```
    The output of the above command should return something similar to
`--config /etc/kubernetes/kubelet/kubelet-config.json` which is the location of
the Kubelet config file.

    Run the following command:

    ```
    stat -c %a /etc/kubernetes/kubelet/kubelet-config.json
    ```
    The output of the above command is the Kubelet config file's permissions.
Verify that the permissions are `644` or more restrictive.
  "
  desc  'fix', "
    Run the following command (using the config file location identied in the
Audit step)

    ```
    chmod 644 /etc/kubernetes/kubelet/kubelet-config.json
    ```
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: nil
  tag gid: nil
  tag rid: nil
  tag stig_id: nil
  tag fix_id: nil
  tag cci: nil
  tag nist: ['AC-6 (9)', 'CM-2']
  tag cis_level: 1
  tag cis_controls: [
    { '6' => ['5.1'] },
    { '7' => ['5.2'] }
  ]
  tag cis_rid: '3.1.3'

  k_conf = file(kubelet.config.first)

  describe.one do
    describe k_conf do
      it { should_not exist }
    end
    describe k_conf do
      it { should_not be_more_permissive_than('0644') }
    end
  end
end
