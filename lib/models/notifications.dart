class NotificationModel {
  String id, message, title, orderNumber, orderStatus, createdAt;
  NotificationModel(
      {this.createdAt,
      this.id,
      this.message,
      this.orderNumber,
      this.orderStatus,
      this.title});
}
