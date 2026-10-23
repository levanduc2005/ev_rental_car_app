import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/booking/domain/entities/bank_app_item.dart';

void main() {
  group('BankAppItem', () {
    test('fromVietQRJson maps fields correctly with default logo and id', () {
      final json = {
        'code': 'MB',
        'shortName': 'MBBank',
        'name': 'Ngân hàng Quân Đội',
        'bin': '970422',
        'logo': 'https://cdn.vietqr.io/img/MB.png',
      };

      final item = BankAppItem.fromVietQRJson(json);

      expect(item.appId, 'mb');
      expect(item.code, 'MB');
      expect(item.shortName, 'MBBank');
      expect(item.name, 'Ngân hàng Quân Đội');
      expect(item.bin, '970422');
      expect(item.logoUrl, 'https://cdn.vietqr.io/img/MB.png');
      expect(item.isPopular, isFalse);
    });

    test(
      'fromVietQRJson falls back gracefully when optional fields are missing',
      () {
        final json = <String, dynamic>{'code': 'TCB'};

        final item = BankAppItem.fromVietQRJson(json);

        expect(item.appId, 'tcb');
        expect(item.code, 'TCB');
        expect(item.shortName, 'TCB');
        expect(item.name, 'TCB');
        expect(item.bin, isNull);
        expect(item.logoUrl, 'https://cdn.vietqr.io/img/TCB.png');
      },
    );

    test('buildDeeplink generates correct URL with beneficiary account name', () {
      const item = BankAppItem(
        appId: 'vcb',
        code: 'VCB',
        name: 'Vietcombank',
        shortName: 'Vietcombank',
        logoUrl: 'https://cdn.vietqr.io/img/VCB.png',
      );

      final link = item.buildDeeplink(
        beneficiaryAccountNumber: '123456789',
        beneficiaryBankCode: 'MB',
        amount: 500000,
        description: 'Thanh toan tien coc xe EV',
        beneficiaryAccountName: 'CONG TY E MOTION',
      );

      expect(
        link,
        'https://dl.vietqr.io/pay?app=vcb&ba=123456789@mb&am=500000&tn=Thanh%20toan%20tien%20coc%20xe%20EV&bn=CONG%20TY%20E%20MOTION',
      );
    });

    test(
      'buildDeeplink generates correct URL without beneficiary account name',
      () {
        const item = BankAppItem(
          appId: 'mb',
          code: 'MB',
          name: 'MBBank',
          shortName: 'MBBank',
          logoUrl: 'https://cdn.vietqr.io/img/MB.png',
        );

        final link = item.buildDeeplink(
          beneficiaryAccountNumber: '987654321',
          beneficiaryBankCode: 'vcb',
          amount: 200000,
          description: 'Coc xe',
        );

        expect(
          link,
          'https://dl.vietqr.io/pay?app=mb&ba=987654321@vcb&am=200000&tn=Coc%20xe',
        );
      },
    );
  });
}
