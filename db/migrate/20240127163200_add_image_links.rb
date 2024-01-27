# frozen_string_literal: true

class AddImageLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :journeys,      :image_links, :jsonb, default: {}
    add_column :journey_stops, :image_links, :jsonb, default: {}
  end
end
