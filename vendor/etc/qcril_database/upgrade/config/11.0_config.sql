
/*
  Copyright (c) 2021 Qualcomm Technologies, Inc.
  All Rights Reserved.
  Confidential and Proprietary - Qualcomm Technologies, Inc.
*/

CREATE TABLE IF NOT EXISTS qcril_properties_table (property TEXT PRIMARY KEY NOT NULL, def_val TEXT, value TEXT);
INSERT OR REPLACE INTO qcril_properties_table(property, def_val) VALUES('qcrildb_version',11.0);
UPDATE qcril_properties_table SET def_val="all" WHERE property="all_bc_msg";
UPDATE qcril_properties_table SET def_val="true" WHERE property="persist.vendor.radio.data_con_rprt";
UPDATE qcril_properties_table SET def_val="0" WHERE property="persist.vendor.radio.custom_ecc";
UPDATE qcril_properties_table SET def_val="1" WHERE property="persist.vendor.radio.cs_srv_type";
UPDATE qcril_properties_table SET def_val="30" WHERE property="persist.vendor.radio.mt_sms_ack";
UPDATE qcril_properties_table SET def_val="true" WHERE property="persist.vendor.radio.process_sups_ind";
