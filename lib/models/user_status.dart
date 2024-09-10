enum UserStatus {
  active('active'),
  inactive('inactive'),
  pending('pending'),
  statusUnavailable('');

  final String value;

  const UserStatus(this.value);
}
