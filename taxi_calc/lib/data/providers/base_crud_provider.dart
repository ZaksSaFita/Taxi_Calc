abstract class BaseCrudProvider<TData, TCompanion> {
  Future<List<TData>> getAll();
  Future<TData?> getById(int id);
  Future<int> create(TCompanion item);
  Future<bool> update(TCompanion item);
  Future<int> delete(int id);
}
