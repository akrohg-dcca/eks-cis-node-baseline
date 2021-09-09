# encoding: UTF-8

control 'eks-cis-4.1.4' do
  title 'draft'
  desc  "The ability to create pods in a namespace can provide a number of
opportunities for privilege escalation, such as assigning privileged service
accounts to these pods or mounting hostPaths with access to sensitive data
(unless Pod Security Policies are implemented to restrict this access)

    As such, access to create new pods should be restricted to the smallest
possible group of users.
  "
  desc  'rationale', "The ability to create pods in a cluster opens up
possibilities for privilege escalation and should be restricted, where
possible."
  desc  'check', "Review the users who have create access to pod objects in the
Kubernetes API."
  desc  'fix', "Where possible, remove `create` access to `pod` objects in the
cluster."
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
  tag cis_rid: '4.1.4'
end

