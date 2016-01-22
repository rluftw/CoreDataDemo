# HitList
A demo application that demonstrates the basic usage of core data.

### Materials covered

- **NSManagedContext** - Can think of a managed object context as an in-memory “scratchpad” for working with managed objects.
- **NSEntityDescription** - An entity description is the piece that links the entity definition from your data model with an instance of NSManagedObject at runtime.
- **NSFetchRequest** - Fetches all objects of a particular entity
- **managedContext.executeFetchRequest(fetchRequest)** - You hand the fetch request over to the managed object context to do the heavy lifting. executeFetchRequest() returns an array of managed objects that meets the criteria specified by the fetch request.

### Important design patterns

KVC is a mechanism in Cocoa and Cocoa Touch for accessing an object’s properties indirectly using strings to identify properties. 

Key-value coding is available to all classes that descend from NSObject, including NSManagedObject. You wouldn’t be able to access properties using KVC on a Swift object that doesn’t descend from NSObject.