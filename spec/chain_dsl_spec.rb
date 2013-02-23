require 'spec_helper'

describe 'Chain DSL' do
  subject :client do
    RestApiClient.chain('http://api.beatport.com/catalog/3')
  end

  describe '.url!' do
    specify { client.url!.should eq('') }
    specify { client.accounts.url!.should eq('accounts') }
    specify { client.accounts(1).url!.should eq('accounts/1') }
    specify { client.accounts(1).projects.url!.should eq('accounts/1/projects') }
    specify { client.accounts.projects.url!.should eq('accounts/projects') }

    context 'reusing a resource' do
      subject :account_1 do
        RestApiClient.chain('http://company.com').accounts(1)
      end

      specify do
        account_1.projects.url!.should eq('accounts/1/projects')
        account_1.users.url!.should eq('accounts/1/users')
      end
    end
  end

  describe '.get!' do
    specify {
      client.genres.get!.should_not be_nil
    }
  end

end