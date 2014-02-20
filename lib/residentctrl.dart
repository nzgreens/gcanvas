part of gcanvas.client;


@reflectable
class ResidentListCtrl {
  @reflectable StoreCtrl _storeCtrl;

  ResidentListCtrl(this._storeCtrl);


  Future<List<Resident>> getResidentsAtAddress(Address address) {
    return _storeCtrl.getResidentsAtAddress(address);
  }


  Future<int> add(Resident resident) {
    return _storeCtrl.addResident(resident);
  }


  Future<bool> remove(Resident resident) {
    return _storeCtrl.removeResident(resident);
  }
}