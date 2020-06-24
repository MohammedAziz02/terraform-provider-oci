// Copyright (c) 2017, 2020, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0

resource "oci_core_vcn" "vcn_rd" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "vcnRD"
  dns_label      = "vcnrd"
}

resource "oci_core_internet_gateway" "internetgateway_rd" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "internetgatewayRD"
  vcn_id         = "${oci_core_vcn.vcn_rd.id}"
}

resource "oci_core_route_table" "routetable_rd" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_vcn.vcn_rd.id}"
  display_name   = "routetableRD"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.internetgateway_rd.id}"
  }
}

resource "oci_core_network_security_group" "network_security_group_rd" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_vcn.vcn_rd.id}"
  display_name   = "displayName"
}

resource "oci_core_network_security_group" "network_security_group_backup_rd" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_vcn.vcn_rd.id}"
  display_name   = "displayName"
}

resource "oci_core_subnet" "subnet_rd" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  cidr_block          = "10.1.20.0/24"
  display_name        = "TestSubnet"
  dns_label           = "testsubnet"
  security_list_ids   = ["${oci_core_vcn.vcn_rd.default_security_list_id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_vcn.vcn_rd.id}"
  route_table_id      = "${oci_core_vcn.vcn_rd.default_route_table_id}"
  dhcp_options_id     = "${oci_core_vcn.vcn_rd.default_dhcp_options_id}"
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = "${var.tenancy_ocid}"
  ad_number      = 1
}
