require "spec_helper"

describe CFAdmin::DefineQuota do
  let(:fake_home_dir) { "#{SPEC_ROOT}/fixtures/fake_home_dir" }

  stub_home_dir_with { fake_home_dir }

  let(:paid_quota) { fake :quota_definition, :name => "paid" }
  let(:free_quota) { fake :quota_definition, :name => "free" }

  let(:organization) do
    fake :organization, :name => "some-org-name",
      :quota_definition => free_quota
  end

  let(:client) do
    fake_client :organizations => [organization],
      :quota_definitions => [paid_quota, free_quota]
  end

  before do
    stub_client
    stub(organization).update!
  end

  context "when given an organization and a quota definition" do
    it "promotes the organization to the given quota definition" do
      expect {
        cf %W[define-quota paid some-org-name]
      }.to change {
        organization.quota_definition
      }.from(free_quota).to(paid_quota)
    end

    it "shows progress to the user" do
      cf %W[define-quota paid some-org-name]
      expect(output).to say("Setting quota of some-org-name to paid... OK")
    end

    it "saves the changes made to the organization" do
      mock(organization).update!
      cf %W[define-quota paid some-org-name]
    end
  end

  context "when NOT given a quota definition" do
    it "prompts for the quota definition" do
      mock_ask("Quota", hash_including(:choices => client.quota_definitions)) do
        paid_quota
      end

      cf %W[define-quota --organization some-org-name]
    end
  end

  context "when NOT given an organization" do
    context "and the user has a current organization" do
      before { client.current_organization = organization }

      it "promotes the current to the given quota definition" do
        expect {
          cf %W[define-quota paid]
        }.to change {
          organization.quota_definition
        }.from(free_quota).to(paid_quota)
      end

      it "saves the changes made to the organization" do
        mock(organization).update!
        cf %W[define-quota paid]
      end
    end

    context "and the user does NOT have a current organization" do
      before { client.current_organization = nil }

      it "prompts for the organization" do
        mock_ask("Organization", hash_including(:choices => client.organizations)) do
          organization
        end

        cf %W[define-quota paid]
      end
    end
  end
end
