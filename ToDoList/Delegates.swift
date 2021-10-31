protocol SaveUserTaskDelegate: AnyObject {
  func saveTask(task: TaskModel)
}

protocol RemoveTaskDelegate: AnyObject {
  func removeTask(task: TaskModel)
}
 
protocol TaskCompletedDelegate: AnyObject {
  func taskComplete(task: TaskModel)
}
