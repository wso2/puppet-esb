#----------------------------------------------------------------------------
#  Copyright (c) 2016 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#----------------------------------------------------------------------------

class wso2esb::params {

  if($::use_hieradata == 'true')
  {
    $template_list        = hiera_array('wso2::template_list')
    $post_install_resources   = hiera('wso2::post_install_resources', { } )
    $post_configure_resources = hiera('wso2::post_configure_resources', { } )
    $post_start_resources     = hiera('wso2::post_start_resources', { } )
  }
  else
  {
    $base_template_list = $wso2base::params::template_list
    $esb_template_list          = []

    $template_list = concat($base_template_list,$esb_template_list)

    $post_install_resources             = undef
    $post_configure_resources           = undef
    $post_start_resources               = undef
    $is_datasource                      = 'wso2_carbon_db'
    $platform_version                   = '4.4.0'
    $patch_list                         = []
  }


}
