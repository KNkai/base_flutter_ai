abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // In starter kit, return true by default or plug in connectivity_plus if desired
    return true;
  }
}
