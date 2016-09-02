# ------------------------------------------------------------------------------
# Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ------------------------------------------------------------------------------

# Manages WSO2 Enterprise Service Bus deployment
class wso2esb (
  # wso2esb specific parameters - start
  $template_list             = $wso2esb::params::template_list,
  # wso2esb specific parameters - end

  # system configuration data
  $packages               = $wso2base::params::packages,
  $file_list              = $wso2base::params::file_list,
  $system_file_list       = $wso2base::params::system_file_list,
  $directory_list         = $wso2base::params::directory_list,
  $hosts_mapping          = $wso2base::params::hosts_mapping,
  $java_home              = $wso2base::params::java_home,
  $prefs_system_root      = $wso2base::params::java_prefs_system_root,
  $prefs_user_root        = $wso2base::params::java_prefs_user_root,
  $java_prefs_system_root = $wso2base::params::java_prefs_system_root,
  $java_prefs_user_root   = $wso2base::params::java_prefs_user_root,

  $master_datasources     = $wso2base::params::master_datasources,
  $registry_mounts        = $wso2base::params::registry_mounts,
  $carbon_home_symlink    = $wso2base::params::carbon_home_symlink,
  $wso2_user              = $wso2base::params::wso2_user,
  $wso2_group             = $wso2base::params::wso2_group,
  $maintenance_mode       = $wso2base::params::maintenance_mode,
  $install_mode           = $wso2base::params::install_mode,
  $install_dir            = $wso2base::params::install_dir,
  $pack_dir               = $wso2base::params::pack_dir,
  $pack_filename          = $wso2base::params::pack_filename,
  $pack_extracted_dir     = $wso2base::params::pack_extracted_dir,
  $hostname               = $wso2base::params::hostname,
  $mgt_hostname           = $wso2base::params::mgt_hostname,
  $worker_node            = $wso2base::params::worker_node,
  $patches_dir            = $wso2base::params::patches_dir,
  $service_name           = $wso2base::params::service_name,
  $service_template       = $wso2base::params::service_template,
  $usermgt_datasource     = $wso2base::params::usermgt_datasource,
  $local_reg_datasource   = $wso2base::params::local_reg_datasource,
  $clustering             = $wso2base::params::clustering,
  $dep_sync               = $wso2base::params::dep_sync,
  $ports                  = $wso2base::params::ports,
  $jvm                    = $wso2base::params::jvm,
  $ipaddress              = $wso2base::params::ipaddress,
  $fqdn                   = $wso2base::params::fqdn,
  $sso_authentication     = $wso2base::params::sso_authentication,
  $user_management        = $wso2base::params::user_management,
  $enable_secure_vault    = $wso2base::params::enable_secure_vault,
  $secure_vault_configs   = $wso2base::params::secure_vault_configs,
  $key_stores             = $wso2base::params::key_stores,

  $patch_list                = $wso2esb::params::patch_list,
  $platform_version          = $wso2esb::params::platform_version,
  $post_install_resources    = $wso2esb::params::post_install_resources,
  $post_configure_resources  = $wso2esb::params::post_configure_resources,
  $post_start_resources      = $wso2esb::params::post_start_resources
  # other paramaters - end

) inherits wso2esb::params {


  ::wso2base::system { "Create system configurations for [product] ${::product_name} [profile] ${::product_profile} ":
    packages          => $packages,
    wso2_group        => $wso2_group,
    wso2_user         => $wso2_user,
    service_name      => $service_name,
    service_template  => $service_template,
    hosts_mapping     => $hosts_mapping,
    prefs_system_root => $prefs_system_root,
    prefs_user_root   => $prefs_user_root
  }

  $carbon_home          = "${install_dir}/${pack_extracted_dir}"

  if ($enable_secure_vault == true) {
    $key_store_password   = $secure_vault_configs['key_store_password']['password']
  }


  ::wso2base::clean_and_install { "Cleaning and Installing $title":
    maintenance_mode      => $maintenance_mode,
    install_mode          => $install_mode,
    pack_filename         => $pack_filename,
    pack_dir              => $pack_dir,
    install_dir           => $install_dir,
    wso2_user             => $wso2_user,
    wso2_group            => $wso2_group,
    carbon_home_symlink   => $carbon_home_symlink,
    hosts_mappings        => $hosts_mapping,
    require               => Wso2base::System["Create system configurations for [product] ${::product_name} [profile] ${::product_profile} "]
  }

  if ($post_install_resources != undef) {
    ::wso2base::resource {
      $post_install_resources:
        require => Wso2base::Clean_and_install["Cleaning and Installing $title"],
        before  => Wso2base::Configure_and_deploy["Configuring and Deploying $title"]
    }
  }

  ::wso2base::configure_and_deploy { "Configuring and Deploying $title":
    install_dir                     => $install_dir,
    patch_list                      => $patch_list,
    patches_dir                     => $patches_dir,
    platform_version                => $platform_version,
    wso2_user                       => $wso2_user,
    wso2_group                      => $wso2_group,
    template_list                   => $template_list,
    directory_list                  => $directory_list,
    file_list                       => $file_list,
    system_file_list                => $system_file_list,
    enable_secure_vault             => $enable_secure_vault,
    key_store_password              => $key_store_password,
    java_home                       => $java_home,
    cert_file                       => $cert_file,
    trust_store_password            => $trust_store_password,
    module_name                     => $title,
    marathon_lb_cert_config_enabled => $marathon_lb_cert_config_enabled,
    require                         => Wso2base::Clean_and_install["Cleaning and Installing $title"]
  }

  if (!empty($post_configure_resources)) {
    ::wso2base::resource {
      $post_configure_resources:
        require => Wso2base::Configure_and_deploy["Configuring and Deploying $title"],
        before  => Wso2base::Start["Starting $title"]
    }
  }

  ::wso2base::start { "Starting $title" :
    service_name => $service_name,
    install_dir  => $install_dir,
    require      => Wso2base::Configure_and_deploy["Configuring and Deploying $title"]
  }

  if (!empty($post_start_resources)) {
    ::wso2base::resource {
      $post_start_resources:
        require => Wso2base::Start["Starting $title"]
    }
  }

}