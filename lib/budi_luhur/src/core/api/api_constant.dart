part of 'api_endpoints.dart';

String normalize(String base) =>
    base.endsWith('/') ? base.substring(0, base.length - 1) : base;

/// The base URL for the backend API.
final String _baseUrlSpo =
    dotenv.env['BASE_URL_SPO'] ??
    (throw Exception('BASE_URL_SPO not found in .env'));

/// The URL for the database-specific API endpoints.
final String _baseUrlInternal =
    dotenv.env['BASE_URL_INTERNAL'] ??
    (throw Exception('BASE_URL_INTERNAL not found in .env'));

/// The base URL for the Internal Budi Luhur backend API.
final String databaseUrl = "${normalize(_baseUrlSpo)}/api";

/// The URL for the internal database-specific API endpoints.
final String databaseInternalUrl = '${normalize(_baseUrlInternal)}/api';
