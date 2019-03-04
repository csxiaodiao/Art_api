require "art_api/version"
require 'rest-client'
require 'json'

module ArtApi
  module Api
    class Configuration
      attr_accessor :site_id, :api_key, :six_post_url, :wp_post_url

      def initialize
        @site_id = ''
        @api_key = ''
        @six_post_url = ''
        @wp_post_url = ''
      end
    end

    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end

      def create_six_art_payload(**opt)
        payload = {
          api_key: configuration.api_key,
          site_id: configuration.site_id,
          id: opt[:id],
          title: opt[:title],
          seo_title: opt[:seo_title],
          keywords: opt[:keywords],
          description: opt[:description],
          filename: opt[:filename],
          content: opt[:content],
          logo: opt[:logo],
          addtime: opt[:addtime],
          cat_id: opt[:cat_id],
          release: opt[:release],
          type: 'article'
        }.compact

        payload
      end

      def create_wp_art_payload(**opt)
        payload = {
          title: opt[:title],
          content: opt[:content],
          categories: opt[:cat_id],
          tags: opt[:tags],
          template: opt[:template],
          sticky: opt[:sticky],
          meta: opt[:meta],
          format: opt[:format],
          ping_status: opt[:ping_status],
          comment_status: opt[:comment_status],
          featured_media: opt[:featured_media],
          excerpt: opt[:excerpt],
          author: opt[:author],
          password: opt[:password],
          slug: opt[:slug],
          date_gmt: opt[:date_gmt],
          date: opt[:date],
          status: 'draft'
        }.compact
        payload.to_json
      end

      # push article to six
      def push_six_art(content)
        post_url = configuration.six_post_url % [configuration.site_id]] 
        payload =  create_six_art_payload(content)
        single_sender(post_url, payload)
      end

      def push_wp_art(content)
        header = {content_type: :json, accept: :json, authorization: configuration.authorization]}
        payload =  create_wp_art_payload(content)
        post_url = configuration.wp_post_url
        single_sender(post_url, payload)
      end

      def single_sender(post_url, payload, header = {})
        response = RestClient.post(post_url, payload, header)
      end

    end

  end
end
