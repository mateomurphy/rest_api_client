require 'spec_helper'


describe 'Match DSL Spec' do
  subject :client do
    RestApiClient.match('http://api.compant.com') do |c|
      c.match 'accounts' => 'accounts'
      c.match 'account' => 'accounts/:id'
      c.match 'account_projects' => 'accounts/:account/projects'
      c.match 'account_project' => 'accounts/:account/projects/:id'
    end
  end

  describe 'generated methods' do
    specify { client.accounts.url.should eq('accounts') }
    specify { client.account(1).url.should eq('accounts/1') }
    specify { client.account_projects(1).url.should eq('accounts/1/projects') }
    specify { client.account_project(1, 2).url.should eq('accounts/1/projects/2') }
  end
end