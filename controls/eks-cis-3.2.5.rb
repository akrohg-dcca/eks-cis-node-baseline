control 'eks-cis-3.2.5' do
  title "Ensure that the --streaming-connection-idle-timeout argument is
  not set to 0"
  desc  'Do not disable timeouts on streaming connections.'
  desc  'rationale', "
    Setting idle timeouts ensures that you are protected against
Denial-of-Service attacks, inactive connections and running out of ephemeral
ports.

    **Note:** By default, `--streaming-connection-idle-timeout` is set to 4
hours which might be too high for your environment. Setting this as appropriate
would additionally ensure that such streaming connections are timed out after
serving legitimate use cases.
  "
  desc 'check', "
    **Audit Method 1:**

    If using a Kubelet configuration file, check that there is an entry for
`streamingConnectionIdleTimeout` is not set to `0`.

    First, SSH to the relevant node:

    Run the following command on each node to find the appropriate Kubelet
config file:

    ```
    ps -ef | grep kubelet
    ```
    The output of the above command should return something similar to
`--config /etc/kubernetes/kubelet/kubelet-config.json` which is the location of
the Kubelet config file.

    Open the Kubelet config file:
    ```
    cat /etc/kubernetes/kubelet/kubelet-config.json
    ```

    Verify that the `streamingConnectionIdleTimeout` argument is not set to `0`.

    If the argument is not present, and there is a Kubelet config file
specified by `--config`, check that it does not set
`streamingConnectionIdleTimeout` to 0.

    **Audit Method 2:**

    If using the api configz endpoint consider searching for the status of
`\"streamingConnectionIdleTimeout\":\"4h0m0s\"` by extracting the live
configuration from the nodes running kubelet.

    Set the local proxy port and the following variables and provide proxy port
number and node name;
    `HOSTNAME_PORT=\"localhost-and-port-number\"`
    `NODE_NAME=\"The-Name-Of-Node-To-Extract-Configuration\" from the output of
\"kubectl get nodes\"`
    ```
    kubectl proxy --port=8001 &

    export HOSTNAME_PORT=localhost:8001 (example host and port number)
    export NODE_NAME=ip-192.168.31.226.ec2.internal (example node name from
\"kubectl get nodes\")

    curl -sSL
\"http://${HOSTNAME_PORT}/api/v1/nodes/${NODE_NAME}/proxy/configz\"
    ```
  "
  desc 'fix', "
    **Remediation Method 1:**

    If modifying the Kubelet config file, edit the kubelet-config.json file
`/etc/kubernetes/kubelet/kubelet-config.json` and set the below parameter to a
non-zero value in the format of #h#m#s

    ```
    \"streamingConnectionIdleTimeout\":
    ```

    **Remediation Method 2:**

    If using a Kubelet config file, edit the file to set
`streamingConnectionIdleTimeout` to a value other than 0.

    If using executable arguments, edit the kubelet service file
`/etc/systemd/system/kubelet.service.d/10-kubelet-args.conf` on each worker
node and add the below parameter at the end of the `KUBELET_ARGS` variable
string.

    ```
    --streaming-connection-idle-timeout=4h0m0s
    ```

    **Remediation Method 3:**

    If using the api configz endpoint consider searching for the status of
`\"streamingConnectionIdleTimeout\":` by extracting the live configuration from
the nodes running kubelet.

    **See detailed step-by-step configmap procedures in [Reconfigure a Node's
Kubelet in a Live
Cluster](https://kubernetes.io/docs/tasks/administer-cluster/reconfigure-kubelet/),
and then rerun the curl statement from audit process to check for kubelet
configuration changes
    ```
    kubectl proxy --port=8001 &

    export HOSTNAME_PORT=localhost:8001 (example host and port number)
    export NODE_NAME=ip-192.168.31.226.ec2.internal (example node name from
\"kubectl get nodes\")

    curl -sSL
\"http://${HOSTNAME_PORT}/api/v1/nodes/${NODE_NAME}/proxy/configz\"
    ```

    **For all three remediations:**
    Based on your system, restart the `kubelet` service and check status

    ```
    systemctl daemon-reload
    systemctl restart kubelet.service
    systemctl status kubelet -l
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
  tag nist: ['SC-7', 'Rev_4']
  tag cis_level: 1
  tag cis_controls: ['9', 'Rev_6']
  tag cis_rid: '3.2.5'

  options = { assignment_regex: /(\S+)?[=](\S+)?/ }
  service_flags = parse_config(service('kubelet').params['ExecStart'].gsub(' ', "\n"), options)

  describe.one do
    describe kubelet_config_file do
      its(['streamingConnectionIdleTimeout']) { should_not cmp '0s' }
    end
    describe 'Kubelet service flag' do
      subject { service_flags }
      its('--streaming-connection-idle-timeout') { should_not cmp '0s' }
    end
  end
end
