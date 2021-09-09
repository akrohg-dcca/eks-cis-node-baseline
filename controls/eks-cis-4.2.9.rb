# encoding: UTF-8

control 'eks-cis-4.2.9' do
  title 'draft'
  desc  'Do not generally permit containers with capabilities'
  desc  'rationale', "
    Containers run with a default set of capabilities as assigned by the
Container Runtime. Capabilities are parts of the rights generally granted on a
Linux system to the root user.

    In many cases applications running in containers do not require any
capabilities to operate, so from the perspective of the principal of least
privilege use of capabilities should be minimized.
  "
  desc  'check', "
    Get the set of PSPs with the following command:

    ```
    kubectl get psp
    ```

    For each PSP, check whether capabilities have been forbidden:

    ```
    kubectl get psp <name> -o=jsonpath='{.spec.requiredDropCapabilities}'
    ```
  "
  desc  'fix', "Review the use of capabilites in applications runnning on your
cluster. Where a namespace contains applicaions which do not require any Linux
capabities to operate consider adding a PSP which forbids the admission of
containers which do not drop all capabilities."
  impact 0.7
  tag severity: 'high'
  tag gtitle: nil
  tag gid: nil
  tag rid: nil
  tag stig_id: nil
  tag fix_id: nil
  tag cci: nil
  tag nist: ['CM-6', 'Rev_4']
  tag cis_level: 2
  tag cis_controls: ['5.1', 'Rev_6']
  tag cis_rid: '4.2.9'
end
