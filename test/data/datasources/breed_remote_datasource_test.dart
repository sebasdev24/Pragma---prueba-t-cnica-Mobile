import 'package:catbreeds/core/errors/exceptions.dart';
import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/data/datasources/breed/breed_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/breed_fixtures.dart';
import '../../helpers/mocks.dart';

Response<dynamic> _response(Object? data, {String? count}) {
  return Response(
    requestOptions: RequestOptions(path: '/breeds'),
    data: data,
    statusCode: 200,
    headers: Headers.fromMap({
      if (count != null) 'pagination-count': [count],
    }),
  );
}

void main() {
  late MockDioClient client;
  late BreedRemoteDataSourceImpl dataSource;

  void stubGet(Future<Either<Failure, Response<dynamic>>> Function() answer) {
    when(
      () => client.get(any(), queryParameters: any(named: 'queryParameters')),
    ).thenAnswer((_) => answer());
  }

  setUp(() {
    client = MockDioClient();
    dataSource = BreedRemoteDataSourceImpl(client);
  });

  group('getBreeds', () {
    test('pide la página y lee el total del header', () async {
      stubGet(() async => Right(_response([abyssinianJson], count: '107')));

      final page = await dataSource.getBreeds(page: 2, limit: 20);

      expect(page.items.single.id, 'abys');
      expect(page.total, 107);
      verify(
        () => client.get('/breeds', queryParameters: {'page': 2, 'limit': 20}),
      ).called(1);
    });

    test('descarta registros malformados sin tumbar la página', () async {
      stubGet(
        () async => Right(
          _response([
            abyssinianJson,
            {'id': 42},
            'basura',
          ], count: '3'),
        ),
      );

      final page = await dataSource.getBreeds(page: 0, limit: 20);

      expect(page.items, hasLength(1));
    });

    test('sin header, una página incompleta se toma como la última', () async {
      stubGet(() async => Right(_response([abyssinianJson])));

      final page = await dataSource.getBreeds(page: 1, limit: 20);

      expect(page.total, 21);
    });

    test('propaga el Failure tipado del cliente', () async {
      stubGet(() async => const Left(NetworkFailure('offline')));

      await expectLater(
        dataSource.getBreeds(page: 0, limit: 20),
        throwsA(
          isA<FailureException>().having(
            (e) => e.failure,
            'failure',
            isA<NetworkFailure>(),
          ),
        ),
      );
    });
  });

  test('searchBreeds pide la imagen adjunta', () async {
    stubGet(() async => Right(_response([abyssinianJson])));

    await dataSource.searchBreeds('aby');

    verify(
      () => client.get(
        '/breeds/search',
        queryParameters: {'q': 'aby', 'attach_image': 1},
      ),
    ).called(1);
  });

  test('una respuesta que no es lista es ParsingFailure', () async {
    stubGet(() async => Right(_response({'oops': true})));

    await expectLater(
      dataSource.searchBreeds('x'),
      throwsA(
        isA<FailureException>().having(
          (e) => e.failure,
          'failure',
          isA<ParsingFailure>(),
        ),
      ),
    );
  });
}
