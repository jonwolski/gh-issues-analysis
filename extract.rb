#!/usr/bin/env ruby

Bundler.require :default
require './hypermedia_paged_collection'
require 'active_support'

Dotenv.load

store = ActiveSupport::Cache.lookup_store(:mem_cache_store, ['localhost:11211'])

stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false, store: store
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack

client = Octokit::Client.new(access_token: ENV['OCTOKIT_ACCESS_TOKEN'])
repos = client.root.rels[:organization_repositories].get(uri: {org: 'Groups360'})
repos = HypermediaPagedCollection.new(repos)
binding.pry
:noop
