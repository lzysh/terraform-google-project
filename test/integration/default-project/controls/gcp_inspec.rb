project_id = input('project_id')

control 'google-compute-project-info' do
  title 'Google Compute Project Info'

  describe google_compute_project_info(project: project_id) do
    it { should exist }
  end
end
