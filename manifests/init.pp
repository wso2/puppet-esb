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

# Manages WSO2 Application Server deployment
class wso2esb (
  # wso2esb specific configuration data
  $esb_wsdl_epr_prefix          = $wso2esb::params::esb_wsdl_epr_prefix,

  $packages               = $wso2esb::params::packages,
  $template_list          = $wso2esb::params::template_list,
  $file_list              = $wso2esb::params::file_list,
  $patch_list             = $wso2esb::params::patch_list,
  $cert_list              = $wso2esb::params::cert_list,
  $system_file_list       = $wso2esb::params::system_file_list,
  $directory_list         = $wso2esb::params::directory_list,
  $hosts_mapping          = $wso2esb::params::hosts_mapping,
  $java_home              = $wso2esb::params::java_home,
  $java_prefs_system_root = $wso2esb::params::java_prefs_system_root,
  $java_prefs_user_root   = $wso2esb::params::java_prefs_user_root,
  $vm_type                = $wso2esb::params::vm_type,
  $wso2_user              = $wso2esb::params::wso2_user,
  $wso2_group             = $wso2esb::params::wso2_group,
  $product_name           = $wso2esb::params::product_name,
  $product_version        = $wso2esb::params::product_version,
  $platform_version       = $wso2esb::params::platform_version,
  $carbon_home_symlink    = $wso2esb::params::carbon_home_symlink,
  $remote_file_url        = $wso2esb::params::remote_file_url,
  $maintenance_mode       = $wso2esb::params::maintenance_mode,
  $install_mode           = $wso2esb::params::install_mode,
  $install_dir            = $wso2esb::params::install_dir,
  $pack_dir               = $wso2esb::params::pack_dir,
  $pack_filename          = $wso2esb::params::pack_filename,
  $pack_extracted_dir     = $wso2esb::params::pack_extracted_dir,
  $patches_dir            = $wso2esb::params::patches_dir,
  $service_name           = $wso2esb::params::service_name,
  $service_template       = $wso2esb::params::service_template,
  $ipaddress              = $wso2esb::params::ipaddress,
  $enable_secure_vault    = $wso2esb::params::enable_secure_vault,
  $secure_vault_configs   = $wso2esb::params::secure_vault_configs,
  $key_stores             = $wso2esb::params::key_stores,
  $carbon_home            = $wso2esb::params::carbon_home,
  $pack_file_abs_path     = $wso2esb::params::pack_file_abs_path,

  # Templated configuration parameters
  $master_datasources     = $wso2esb::params::master_datasources,
  $registry_mounts        = $wso2esb::params::registry_mounts,
  $hostname               = $wso2esb::params::hostname,
  $mgt_hostname           = $wso2esb::params::mgt_hostname,
  $worker_node            = $wso2esb::params::worker_node,
  $usermgt_datasource     = $wso2esb::params::usermgt_datasource,
  $local_reg_datasource   = $wso2esb::params::local_reg_datasource,
  $clustering             = $wso2esb::params::clustering,
  $dep_sync               = $wso2esb::params::dep_sync,
  $ports                  = $wso2esb::params::ports,
  $jvm                    = $wso2esb::params::jvm,
  $fqdn                   = $wso2esb::params::fqdn,
  $sso_authentication     = $wso2esb::params::sso_authentication,
  $user_management        = $wso2esb::params::user_management
) inherits wso2esb::params {

  validate_string($is_datasource)

  class { '::wso2base':
    packages               => $packages,
    template_list          => $template_list,
    file_list              => $file_list,
    patch_list             => $patch_list,
    cert_list              => $cert_list,
    system_file_list       => $system_file_list,
    directory_list         => $directory_list,
    hosts_mapping          => $hosts_mapping,
    java_home              => $java_home,
    java_prefs_system_root => $java_prefs_system_root,
    java_prefs_user_root   => $java_prefs_user_root,
    vm_type                => $vm_type,
    wso2_user              => $wso2_user,
    wso2_group             => $wso2_group,
    product_name           => $product_name,
    product_version        => $product_version,
    platform_version       => $platform_version,
    carbon_home_symlink    => $carbon_home_symlink,
    remote_file_url        => $remote_file_url,
    maintenance_mode       => $maintenance_mode,
    install_mode           => $install_mode,
    install_dir            => $install_dir,
    pack_dir               => $pack_dir,
    pack_filename          => $pack_filename,
    pack_extracted_dir     => $pack_extracted_dir,
    patches_dir            => $patches_dir,
    service_name           => $service_name,
    service_template       => $service_template,
    ipaddress              => $ipaddress,
    enable_secure_vault    => $enable_secure_vault,
    secure_vault_configs   => $secure_vault_configs,
    key_stores             => $key_stores,
    carbon_home            => $carbon_home,
    pack_file_abs_path     => $pack_file_abs_path
  }

  contain wso2base
  contain wso2base::system
  contain wso2base::clean
  contain wso2base::install
  contain wso2base::configure
  contain wso2base::service

  Class['::wso2base'] -> Class['::wso2base::system']
  -> Class['::wso2base::clean'] -> Class['::wso2base::install']
  -> Class['::wso2base::configure'] ~> Class['::wso2base::service']
}