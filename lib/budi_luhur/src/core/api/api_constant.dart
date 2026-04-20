part of 'api_client.dart';

String normalize(String base) =>
    base.endsWith('/') ? base.substring(0, base.length - 1) : base;

final String _baseUrlInternal =
    dotenv.env['BASE_URL_INTERNAL'] ??
    (throw Exception('BASE_URL_INTERNAL not found in .env'));

final String _baseSanctum =
    dotenv.env['BASE_URL_SANCTUM'] ??
    (throw Exception('BASE_URL_SANCTUM not found in .env'));

final String sanctumUrl = "${normalize(_baseSanctum)}/api";

final String databaseInternalUrl = '${normalize(_baseUrlInternal)}/api';
