# frozen_string_literal: true

# Copyright 2018 ACT, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#     You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#         limitations under the License.

MIGRATION_CLASS =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration["#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"]
  else
    ActiveRecord::Migration
  end

class CreateMinervaTables < MIGRATION_CLASS
  def change
    enable_extension 'plpgsql'
    enable_extension 'btree_gin'
    enable_extension 'fuzzystrmatch'
    enable_extension 'hstore'
    enable_extension 'intarray'
    enable_extension 'pg_stat_statements'
    enable_extension 'pg_trgm'
    enable_extension 'pgcrypto'
    enable_extension 'citext'

    create_table 'alignments', id: :serial, force: :cascade do |t|
      t.integer 'resource_id', null: false
      t.integer 'taxonomy_id', null: false
      t.integer 'status', null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.index ['created_at'], name: 'index_alignments_on_created_at'
      t.index %w[resource_id taxonomy_id], name: 'index_alignments_on_resource_id_and_taxonomy_id', unique: true
      t.index ['status'], name: 'index_alignments_status'
      t.index %w[taxonomy_id resource_id], name: 'index_alignments_on_taxonomy_id_and_resource_id'
    end

    create_table 'resource_stats', id: :serial, force: :cascade do |t|
      t.integer 'effectiveness', null: false
      t.integer 'taxonomy_id', null: false
      t.integer 'resource_id', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.string 'taxonomy_ident', limit: 255, null: false
      t.integer 'consumption_count', null: false
      t.index ['effectiveness'], name: 'index_resource_stats_on_effectiveness'
      t.index %w[resource_id taxonomy_id], name: 'index_resource_stats_on_resource_id_and_taxonomy_id', unique: true
    end

    create_table 'resources', id: :serial, force: :cascade do |t|
      t.citext 'name', null: false
      t.tsvector 'tsv_name'
      t.citext 'description'
      t.tsvector 'tsv_description'
      t.string 'url', limit: 255
      t.string 'cover', limit: 255
      t.jsonb 'lti_link', default: {}
      t.citext 'learning_resource_type'
      t.citext 'language', default: 'en'
      t.text 'thumbnail_url'
      t.jsonb 'text_complexity', default: {}
      t.citext 'author'
      t.citext 'publisher', null: false
      t.citext 'use_rights_url'
      t.bigint 'time_required'
      t.citext 'technical_format'
      t.jsonb 'extensions', default: {}
      t.citext 'educational_audience', default: [], null: false, array: true
      t.citext 'accessibility_api', default: [], null: false, array: true
      t.citext 'accessibility_input_methods', default: [], null: false, array: true
      t.citext 'accessibility_features', default: [], null: false, array: true
      t.citext 'accessibility_hazards', default: [], null: false, array: true
      t.citext 'access_mode', default: [], null: false, array: true
      t.date 'publish_date'
      t.integer 'direct_taxonomy_ids', default: [], null: false, array: true
      t.integer 'all_taxonomy_ids', default: [], null: false, array: true
      t.integer 'resource_stat_ids', default: [], null: false, array: true
      t.integer 'all_subject_ids', default: [], null: false, array: true
      t.tsvector 'tsv_subjects'
      t.jsonb 'efficacy'
      t.integer 'avg_efficacy', default: 0
      t.integer 'min_age'
      t.integer 'max_age'
      t.integer 'rating'
      t.boolean 'embeddable', null: false, default: false
      t.string 'youtube_id'
      t.string 'thumbnail'
      t.tsvector 'tsv_text'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index "(((text_complexity ->> 'flesch-kincaid'::text))::double precision)", name: 'text_complexity_flesch-kincaid'
      t.index "(((text_complexity ->> 'lexile'::text))::double precision)", name: 'text_complexity_lexile'
      t.index 'author gin_trgm_ops', name: 'index_resources_on_author_trgm', using: :gin
      t.index 'description gin_trgm_ops', name: 'index_resources_on_description_trgm', using: :gin
      t.index 'language gin_trgm_ops', name: 'index_resources_on_language_trgm', using: :gin
      t.index 'learning_resource_type gin_trgm_ops', name: 'index_resources_on_learning_resource_type_trgm', using: :gin
      t.index 'name gin_trgm_ops, name', name: 'index_resources_on_name_trgm', using: :gin
      t.index 'publisher gin_trgm_ops', name: 'index_resources_on_publisher_trgm', using: :gin
      t.index 'technical_format gin_trgm_ops', name: 'index_resources_on_technical_format_trgm', using: :gin
      t.index 'direct_taxonomy_ids gin__int_ops', name: 'index_resources_on_direct_taxonomy_ids', using: :gin
      t.index 'all_taxonomy_ids gin__int_ops', name: 'index_resources_on_all_taxonomy_ids', using: :gin
      t.index 'resource_stat_ids gin__int_ops', name: 'index_resources_on_resource_stat_ids', using: :gin
      t.index 'use_rights_url gin_trgm_ops', name: 'index_resources_on_use_rights_url_trgm', using: :gin
      t.index ['min_age'], name: 'index_resources_min_age'
      t.index ['max_age'], name: 'index_resources_max_age'
      t.index ['created_at'], name: 'index_resources_on_created_at'
      t.index ['language'], name: 'index_resources_language'
      t.index ['learning_resource_type'], name: 'index_resources_on_learning_resource_type'
      t.index ['name'], name: 'index_resources_name'
      t.index ['rating'], name: 'index_resources_rating'
      t.index ['technical_format'], name: 'index_resources_technical_format'
      t.index ['time_required'], name: 'index_resources_time_required'
      t.index ['tsv_text'], name: 'index_resources_on_tsv_text_gin', using: :gin
    end

    create_table 'resources_subjects', id: :serial, force: :cascade do |t|
      t.integer 'resource_id'
      t.integer 'subject_id'
      t.index %w[resource_id subject_id], name: 'index_res_subj_on_res_id_and_subj_id'
      t.index %w[subject_id resource_id], name: 'index_subj_res_on_res_id_and_subj_id', unique: true
    end

    create_table 'sub_resources', id: :serial, force: :cascade do |t|
      t.integer 'parent_id'
      t.integer 'child_id'
      t.index %w[child_id parent_id], name: 'index_sub_resources_on_child_id_and_parent_id'
      t.index %w[parent_id child_id], name: 'index_sub_resources_on_parent_id_and_child_id', unique: true
    end

    create_table 'subjects', id: :serial, force: :cascade do |t|
      t.citext 'name'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.citext 'description'
      t.string 'ancestry'
      t.index 'name gin_trgm_ops', name: 'index_subjects_on_name_gin', using: :gin
      t.index ['name'], name: 'index_subjects_on_name', unique: true
    end

    create_table 'taxonomies', id: :serial, force: :cascade do |t|
      t.citext 'identifier'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.integer 'min_age'
      t.integer 'max_age'
      t.citext 'description'
      t.string 'ancestry'
      t.string 'alignment_type'
      t.integer 'ancestry_depth', default: 0
      t.citext 'source'
      t.citext 'name'
      t.citext 'opensalt_identifier'
      t.text 'aliases', default: [], null: false, array: true
      t.index 'identifier gin_trgm_ops', name: 'index_taxonomy_on_identifier_gin', using: :gin
      t.index ['ancestry'], name: 'index_taxonomy_on_ancestry'
      t.index ['aliases'], name: 'index_taxonomies_on_aliases', using: :gin
      t.index ['min_age'], name: 'index_taxonomies_on_min_age'
      t.index ['max_age'], name: 'index_taxonomies_on_max_age'
      t.index ['description'], name: 'index_taxonomies_on_description'
      t.index ['identifier'], name: 'index_taxonomies_on_name'
      t.index ['opensalt_identifier'], name: 'index_taxonomies_on_opensalt_identifier'
      t.index ['source'], name: 'index_taxonomies_on_source'
    end

    create_table 'taxonomy_mappings', id: :serial, force: :cascade do |t|
      t.integer 'taxonomy_id'
      t.integer 'target_id'
      t.integer 'state'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['target_id'], name: 'index_taxonomy_mappings_target_id'
      t.index ['taxonomy_id'], name: 'index_taxonomy_mappings_taxonomy_id'
    end

  end
end
