trigger OrderTrigger on Order (before insert, before update, after delete, before delete) {
    new OrderTriggerHandler().run();
}