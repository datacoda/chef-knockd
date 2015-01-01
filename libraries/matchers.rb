if defined?(ChefSpec)
  ChefSpec.define_matcher :knockd_client

  def run_knockd_client(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:knockd_client, :run, resource_name)
  end
end
