require 'spec_helper'

describe URITemplate do
  specify do
    template = URITemplate.new(:colon, 'account/:account/projects/:id')
    key = template.variables
    value = [1, 2]

    #TODO colon syntax doesn't support underscores??
    vars = Hash[*key.zip(value).flatten]
    vars.should eq({"account"=>1, "id"=>2})
  end
end