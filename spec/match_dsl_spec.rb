require 'spec_helper'

describe 'Match DSL Spec' do
  context 'using #match' do
    subject :client do
      RestApiClient.match('http://api.compant.com') do |c|
        c.match :accounts => 'accounts'
        c.match :account => 'accounts/:id'
        c.match :account_projects => 'accounts/:account/projects'
        c.match :account_project => 'accounts/:account/projects/:id'
      end
    end

    describe 'generated methods' do
      specify { client.accounts.url.should eq('accounts') }
      specify { client.account(1).url.should eq('accounts/1') }
      specify { client.account_projects(1).url.should eq('accounts/1/projects') }
      specify { client.account_project(1, 2).url.should eq('accounts/1/projects/2') }
    end
  end

  context 'using #resources' do
    subject :client do
      RestApiClient.match('http://api.compant.com') do |c|
        c.resources :accounts do
          c.resources :projects
          c.resource :settings
        end
        c.resource :user do
          c.resources :projects
        end
      end
    end

    describe 'generated methods' do
      specify { client.accounts.url.should eq('accounts') }
      specify { client.account(1).url.should eq('accounts/1') }
      specify { client.account_projects(1).url.should eq('accounts/1/projects') }
      specify { client.account_project(1, 2).url.should eq('accounts/1/projects/2') }
      specify { client.account_settings(1).url.should eq('accounts/1/settings') }
      specify { client.user.url.should eq('user') }
      specify { client.user_projects.url.should eq('user/projects') }
    end
  end
end