import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
part 'db.g.dart';

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(dbModel)
const dbModel = SqfEntityModel(
    modelName: 'dbModel', // optional
    databaseName: 'easymovein.db',
    // put defined tables into the tables list.
    databaseTables: [
      TableMkrtUnits,
      TblElectrics,
      TblWaters,
      TblElectricsTempQC,
      TblWatersTempQC,
      TblElectricsTemp,
      TblWatersTemp,
      TblMasterProblem,
      TblWatersTempProblem,
      TblElectricsTempProblem,
      TblWatersTempProblemQC,
      TblElectricsTempProblemQC
    ],
    sequences: [seqIdentity],
    // put defined sequences into the sequences list.
    bundledDatabasePath:
        null // 'assets/sample.db' // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
    );

const TableMkrtUnits = SqfEntityTable(
    tableName: 'tbl_mkrt_units',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("unit_code", DbType.text),
      SqfEntityField("blocks", DbType.text),
      SqfEntityField("tower", DbType.text),
      SqfEntityField("floor", DbType.text),
      SqfEntityField("tipe", DbType.text),
      SqfEntityField("customer_name", DbType.text),
      SqfEntityField("customer_address", DbType.text),
      SqfEntityField("email", DbType.text),
      SqfEntityField("electric_id", DbType.text),
      SqfEntityField("water_id", DbType.text),
      SqfEntityField("phone", DbType.text),
      SqfEntityField("pppu", DbType.text),
      SqfEntityField("date_pppu", DbType.text),
      SqfEntityField("date_ho", DbType.text),
      SqfEntityField("eligible", DbType.text),
      SqfEntityField("tanggal_dari", DbType.text),
      SqfEntityField("tanggal_sampai", DbType.text),
      SqfEntityField("ho", DbType.text),
      SqfEntityField("water", DbType.text),
      SqfEntityField("electric", DbType.text),
      SqfEntityField("water_color", DbType.text),
      SqfEntityField("electric_color", DbType.text),
      SqfEntityField("sync_date", DbType.text)
    ]);

const TblElectrics = SqfEntityTable(
    tableName: 'tbl_electrics',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("idx", DbType.text),
      SqfEntityField("unit_code", DbType.text),
      SqfEntityField("bulan", DbType.text),
      SqfEntityField("tahun", DbType.text),
      SqfEntityField("meteran", DbType.text),
      SqfEntityField("foto", DbType.text),
      SqfEntityField("tanggalinput", DbType.text),
      SqfEntityField("petugas", DbType.text),
      SqfEntityField("pemakaian", DbType.text),
      SqfEntityField("sync_date", DbType.text),
    ]);

const TblWaters = SqfEntityTable(
    tableName: 'tbl_waters',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("idx", DbType.text),
      SqfEntityField("unit_code", DbType.text),
      SqfEntityField("bulan", DbType.text),
      SqfEntityField("tahun", DbType.text),
      SqfEntityField("meteran", DbType.text),
      SqfEntityField("foto", DbType.text),
      SqfEntityField("tanggalinput", DbType.text),
      SqfEntityField("petugas", DbType.text),
      SqfEntityField("pemakaian", DbType.text),
      SqfEntityField("sync_date", DbType.text),
    ]);

const TblElectricsTemp = SqfEntityTable(
    tableName: 'tbl_electrics_temp',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("id", DbType.integer),
      SqfEntityField("unit_code", DbType.text),
      SqfEntityField("type", DbType.text),
      SqfEntityField("bulan", DbType.text),
      SqfEntityField("tahun", DbType.text),
      SqfEntityField("nomor_seri", DbType.text),
      SqfEntityField("pemakaian", DbType.text),
      SqfEntityField("foto", DbType.text),
      SqfEntityField("insert_date", DbType.text),
      SqfEntityField("insert_by", DbType.text),
      SqfEntityField("problem", DbType.text)
    ]);

const TblWatersTemp = SqfEntityTable(
    tableName: 'tbl_waters_temp',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("id", DbType.integer),
      SqfEntityField("unit_code", DbType.text),
      SqfEntityField("type", DbType.text),
      SqfEntityField("bulan", DbType.text),
      SqfEntityField("tahun", DbType.text),
      SqfEntityField("nomor_seri", DbType.text),
      SqfEntityField("pemakaian", DbType.text),
      SqfEntityField("foto", DbType.text),
      SqfEntityField("insert_date", DbType.text),
      SqfEntityField("insert_by", DbType.text),
      SqfEntityField("problem", DbType.text)
    ]);

const TblElectricsTempQC = SqfEntityTable(
    tableName: 'tbl_electrics_temp_qc',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("id", DbType.integer),
      SqfEntityField("unit_code", DbType.text),
      SqfEntityField("type", DbType.text),
      SqfEntityField("bulan", DbType.text),
      SqfEntityField("tahun", DbType.text),
      SqfEntityField("qc_check", DbType.text),
      SqfEntityField("qc_date", DbType.text),
      SqfEntityField("qc_id", DbType.text)
    ]);

const TblWatersTempQC = SqfEntityTable(
    tableName: 'tbl_waters_temp_qc',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("id", DbType.integer),
      SqfEntityField("unit_code", DbType.text),
      SqfEntityField("type", DbType.text),
      SqfEntityField("bulan", DbType.text),
      SqfEntityField("tahun", DbType.text),
      SqfEntityField("qc_check", DbType.text),
      SqfEntityField("qc_date", DbType.text),
      SqfEntityField("qc_id", DbType.text)
    ]);

const TblWatersTempProblem = SqfEntityTable(
    tableName: 'tbl_waters_temp_problem',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("id", DbType.integer),
      SqfEntityField("unit_code", DbType.text),
      SqfEntityField("bulan", DbType.text),
      SqfEntityField("tahun", DbType.text),
      SqfEntityField("idx_problem", DbType.text)
    ]);

const TblElectricsTempProblem = SqfEntityTable(
    tableName: 'tbl_electrics_temp_problem',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("id", DbType.integer),
      SqfEntityField("unit_code", DbType.text),
      SqfEntityField("bulan", DbType.text),
      SqfEntityField("tahun", DbType.text),
      SqfEntityField("idx_problem", DbType.text)
    ]);

const TblWatersTempProblemQC = SqfEntityTable(
    tableName: 'tbl_waters_temp_problem_qc',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("id", DbType.integer),
      SqfEntityField("unit_code", DbType.text),
      SqfEntityField("bulan", DbType.text),
      SqfEntityField("tahun", DbType.text),
      SqfEntityField("idx_problem", DbType.text)
    ]);

const TblElectricsTempProblemQC = SqfEntityTable(
    tableName: 'tbl_electrics_temp_problem_qc',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("id", DbType.integer),
      SqfEntityField("unit_code", DbType.text),
      SqfEntityField("bulan", DbType.text),
      SqfEntityField("tahun", DbType.text),
      SqfEntityField("idx_problem", DbType.text)
    ]);

const TblMasterProblem = SqfEntityTable(
    tableName: 'tbl_master_problem',
    primaryKeyName: 'ROWID',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField("id", DbType.integer),
      SqfEntityField("idx", DbType.text),
      SqfEntityField("problem", DbType.text),
      SqfEntityField("type", DbType.text),
      SqfEntityField("is_checked", DbType.bool, defaultValue: false)
    ]);
