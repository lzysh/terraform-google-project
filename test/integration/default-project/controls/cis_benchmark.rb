require_controls 'inspec-gcp-cis-benchmark' do
  control 'cis-gcp-1.1-iam'
  control 'cis-gcp-1.5-iam'
  control 'cis-gcp-1.6-iam'
  control 'cis-gcp-2.2-logging'
  control 'cis-gcp-3.1-networking'
  control 'cis-gcp-4.4-vms'
end
