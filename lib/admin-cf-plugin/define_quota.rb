require "cf/cli"

module CFAdmin
  class DefineQuota < CF::CLI
    def precondition
      check_target
    end

    desc "Change the quota definition for the given (or current) organization."
    group :admin
    input :quota_definition, :argument => :optional,
          :from_given => by_name(:quota_definition)
    input :organization, :argument => :optional,
          :from_given => by_name(:organization),
          :default => proc { client.current_organization || interact }
    def define_quota
      org = input[:organization]
      quota = input[:quota_definition]

      with_progress(<<MESSAGE.chomp) do
Setting quota of #{c(org.name, :name)} to #{c(quota.name, :name)}
MESSAGE
        org.quota_definition = quota
        org.update!
      end
    end

    private

    def ask_quota_definition
      ask("Quota",
          :choices => client.quota_definitions,
          :display => proc(&:name))
    end

    def ask_organization
      ask("Organization",
          :choices => client.organizations,
          :display => proc(&:name))
    end
  end
end
