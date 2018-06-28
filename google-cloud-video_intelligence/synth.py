# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""This script is used to synthesize generated parts of this library."""

import synthtool as s
import synthtool.gcp as gcp
import logging

logging.basicConfig(level=logging.DEBUG)

gapic = gcp.GAPICGenerator()

v1_library = gapic.ruby_library(
    'videointelligence', 'v1',
    artman_output_name='google-cloud-ruby/google-cloud-video_intelligence'
)
s.copy(v1_library / 'lib/google/cloud/video_intelligence/v1')
s.copy(v1_library / 'lib/google/cloud/video_intelligence/v1.rb')
s.copy(v1_library / 'lib/google/cloud/videointelligence/v1')
s.copy(v1_library / 'test/google/cloud/video_intelligence/v1')

# Copy base module from the v1 library so v1 is the default
s.copy(v1_library / 'lib/google/cloud/video_intelligence.rb')

# https://github.com/googleapis/gapic-generator/issues/2117
s.replace(
    'test/google/cloud/video_intelligence/v1/video_intelligence_service_client_test.rb',
    'CustomTestError', 'CustomTestError_v1')
s.replace(
    'test/google/cloud/video_intelligence/v1/video_intelligence_service_client_test.rb',
    'MockGrpcClientStub', 'MockGrpcClientStub_v1')
s.replace(
    'test/google/cloud/video_intelligence/v1/video_intelligence_service_client_test.rb',
    'MockVideoIntelligenceServiceCredentials',
    'MockVideoIntelligenceServiceCredentials_v1')

v1beta1_library = gapic.ruby_library(
    'videointelligence', 'v1beta1',
    artman_output_name='google-cloud-ruby/google-cloud-video_intelligence'
)
s.copy(v1beta1_library / 'lib/google/cloud/video_intelligence/v1beta1')
s.copy(v1beta1_library / 'lib/google/cloud/video_intelligence/v1beta1.rb')
s.copy(v1beta1_library / 'lib/google/cloud/videointelligence/v1beta1')
s.copy(v1beta1_library / 'test/google/cloud/video_intelligence/v1beta1')

# https://github.com/googleapis/gapic-generator/issues/2117
s.replace(
    'test/google/cloud/video_intelligence/v1beta1/video_intelligence_service_client_test.rb',
    'CustomTestError', 'CustomTestError_v1beta1')
s.replace(
    'test/google/cloud/video_intelligence/v1beta1/video_intelligence_service_client_test.rb',
    'MockGrpcClientStub', 'MockGrpcClientStub_v1beta1')
s.replace(
    'test/google/cloud/video_intelligence/v1beta1/video_intelligence_service_client_test.rb',
    'MockVideoIntelligenceServiceCredentials',
    'MockVideoIntelligenceServiceCredentials_v1beta1')

v1beta2_library = gapic.ruby_library(
    'videointelligence', 'v1beta2',
    artman_output_name='google-cloud-ruby/google-cloud-video_intelligence'
)
s.copy(v1beta2_library / 'lib/google/cloud/video_intelligence/v1beta2')
s.copy(v1beta2_library / 'lib/google/cloud/video_intelligence/v1beta2.rb')
s.copy(v1beta2_library / 'lib/google/cloud/videointelligence/v1beta2')
s.copy(v1beta2_library / 'test/google/cloud/video_intelligence/v1beta2')

# https://github.com/googleapis/gapic-generator/issues/2117
s.replace(
    'test/google/cloud/video_intelligence/v1beta2/video_intelligence_service_client_test.rb',
    'CustomTestError', 'CustomTestError_v1beta2')
s.replace(
    'test/google/cloud/video_intelligence/v1beta2/video_intelligence_service_client_test.rb',
    'MockGrpcClientStub', 'MockGrpcClientStub_v1beta2')
s.replace(
    'test/google/cloud/video_intelligence/v1beta2/video_intelligence_service_client_test.rb',
    'MockVideoIntelligenceServiceCredentials',
    'MockVideoIntelligenceServiceCredentials_v1beta2')
