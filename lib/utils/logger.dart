import 'package:hooks_riverpod/hooks_riverpod.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase<dynamic> provider, Object? oldValue,
      Object? newValue, ProviderContainer _container) {
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "oldValue": "$oldValue"
  "newValue": "$newValue"
}''');
  }
}
