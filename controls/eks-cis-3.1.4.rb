# encoding: UTF-8

control 'eks-cis-3.1.4' do
  title "Ensure that the kubelet configuration file ownership is set to
  root:root"
  desc  "Ensure that if the kubelet refers to a configuration file with 
  the --config argument, that file is owned by root:root."
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
    stat -c %U:%G /etc/kubernetes/kubelet/kubelet-config.json
    ```
    The output of the above command is the Kubelet config file's ownership.
Verify that the ownership is set to `root:root`
  "
  desc  'fix', "
    Run the following command (using the config file location identified in the
Audit step)

    ```
    chown root:root /etc/kubernetes/kubelet/kubelet-config.json
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
  tag nist: ['CM-6', 'Rev_4']
  tag cis_level: 1
  tag cis_controls: ['5.1', 'Rev_6']
  tag cis_rid: '3.1.4'

  kubelet_config = input('kubelet_config')

  if service('kubelet').running? && !kubelet_config.empty?
    describe file(kubelet_config) do
      its('owner') { should eq 'root' }
      its('group') { should eq 'root' }
    end
  else
    describe "kubelet not running or not using the --config flag" do
      skip "kubelet not running or not using the --config flag"
    end
  end
end