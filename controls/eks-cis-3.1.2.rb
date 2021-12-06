# encoding: UTF-8

control 'eks-cis-3.1.2' do
  title "If `kubelet` is running, ensure that the file ownership of its
kubeconfig file is set to `root:root`."
  desc  'rationale', "The kubeconfig file for `kubelet` controls various
parameters for the `kubelet` service in the worker node. You should set its
file ownership to maintain the integrity of the file. The file should be owned
by `root:root`."
  desc  'check', "
    SSH to the worker nodes

    To check to see if the Kubelet Service is running:
    ```
    sudo systemctl status kubelet
    ```
    The output should return `Active: active (running) since..`

    Run the following command on each node to find the appropriate kubeconfig
file:

    ```
    ps -ef | grep kubelet
    ```
    The output of the above command should return something similar to
`--kubeconfig /var/lib/kubelet/kubeconfig` which is the location of the
kubeconfig file.

    Run this command to obtain the kubeconfig file ownership:

    ```
    stat -c %U:%G /var/lib/kubelet/kubeconfig
    ```

    The output of the above command gives you the kubeconfig file's ownership.
Verify that the ownership is set to `root:root`.
  "
  desc  'fix', "
    Run the below command (based on the file location on your system) on the
each worker node. For example,

    ```
    chown root:root <proxy kubeconfig file>
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
  tag cis_rid: '3.1.2'

  kubeconfig = input('kubeconfig')

  if service('kubelet').running? && !kubeconfig.empty?
    describe file(kubeconfig) do
      its('owner') { should eq 'root' }
      its('group') { should eq 'root' }
    end
  else
    describe "kubelet not running or not using a kubeconfig file" do
      skip "kubelet not running or not using a kubeconfig file"
    end
  end
end

