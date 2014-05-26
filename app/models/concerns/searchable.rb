module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model


    # Customize the index name
    #
    index_name [Rails.application.engine_name, Rails.env].join('_')

    # Set up index configuration and mapping
    #
    settings index: { number_of_shards: 1, number_of_replicas: 0 } do
      mapping do
        # indexes :title, type: 'multi_field' do
          indexes :title, analyzer: 'standard'
        #   indexes :tokenized, analyzer: 'simple'
        # end
           indexes :loc, type: 'geo_point'
      end
    end

    # Set up callbacks for updating the index on model changes
    
    after_commit lambda { Indexer.perform_async(:index,  self.class.to_s, self.id) }, on: :create
    after_commit lambda { Indexer.perform_async(:update, self.class.to_s, self.id) }, on: :update
    after_commit lambda { Indexer.perform_async(:delete, self.class.to_s, self.id) }, on: :destroy
    after_touch  lambda { Indexer.perform_async(:update, self.class.to_s, self.id) }

    # Customize the JSON serialization for Elasticsearch
    #
    def as_indexed_json(options={})
      as_json.merge(loc: location_coor, 
        title: self.title,
        loc: location_coor,
        location: location_obj,
        tags: tag_array,
        id_user: id_user_number,
        owner_name: owner_name,
        owner_image_url: owner_image_url,
        image_url: image_url)
    end

    def self.search(query)
      # Prefill and set the filters (top-level `filter` and `facet_filter` elements)
      #
      __set_filters = lambda do |key, f|

        @search_definition[:filter][:and] ||= []
        @search_definition[:filter][:and]  |= [f]

        @search_definition[:facets][key.to_sym][:facet_filter][:and] ||= []
        @search_definition[:facets][key.to_sym][:facet_filter][:and]  |= [f]
      end

      @search_definition = {
          query: {},
          filter: {
              geo_distance: {
                  distance: query[:radius].to_s+"km",
                  loc: {
                    lon: query[:longitude].to_f,
                    lat: query[:latitude].to_f
                      }
                  }
            }
        }

         if(query[:title].present?)
            @search_definition[:query] = {
              prefix:  { title: query[:title].downcase! } 
            }
        else
          @search_definition[:query] = { match_all: {} }
        end
        __elasticsearch__.search(@search_definition)
     end

    def location_obj
      self.location.as_json(except: [:created_at, :updated_at])
    end

    def tag_array
      self.tags.map(&:name)
    end

    def id_user_number
      user_obj.id_user
    end

    def owner_name
      user_obj.first_name.to_s + " " + user_obj.last_name.to_s
    end

    def owner_image_url
      "#{Code.host_url}#{user_obj.profile_image}"
    end

    def image_url
      return self.ext_image_url if self.image.url.index("default") && self.ext_image_url.present? &&  !self.ext_image_url.index("nocover")
      image_path = ActionController::Base.helpers.asset_path(self.image.url)
      "#{Code.host_url}#{image_path}"
    end

    def user_obj
     @user ||= self.user
    end
  end
end



