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

Minerva.configure do |config|
  # Specify authorization logic, will be executed in before_action
  config.authorizer = proc do |controller|
    #Authorization goes here
  end

  # To extend search logic you can specify search fields
  # e.g config.extension_fields = [
  # Minerva::FieldTypes::JSONField.new('featured', 'resources.opened', :featured, as_option: :opened),
  # FieldTypes::CaseInsensitiveString.new('some_field', 'resources.some_field', :some_field, is_sortable: true)]

  config.extension_fields = []
  config.carrierwave = { storage: :aws, versions: [{ name: :large, size_w_h: [500,500] },
                                                   { name: :medium, size_w_h: [200,200] }] }
  config.search_by_taxonomy_aliases = true

  config.admin_auth_proc = Proc.new do |controller|
    controller.authenticate_or_request_with_http_basic('Minerva') do |username, password|
      username == password && password == 'admin'
    end
  end
end
