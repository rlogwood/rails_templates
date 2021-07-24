Board.create(name: 'Home', description: 'all things related to home')
Board.create(name: 'Vacation', description: 'vacation planning')

List.create(name: 'Home Repairs', board_id: 1)
List.create(name: 'Grounds Maintenance', board_id: 1)
List.create(name: 'Find perfect spot', board_id: 2)

Task.create(summary: 'replace bath sink cabinet',
            description: 'Old cabinet has deteriorated. Replace with a new one', list_id: 1)

Task.create(summary: 'read vacation blogs', description: 'learn from others', list_id: 3)

Task.create(summary: 'cut grass', description: 'lawn care', list_id: 2)

Step.create(order: 1, description: 'turn off water and disconnect sink fittings', task_id: 1)
Step.create(order: 2, description: 'lift sink out of cabinet', task_id: 1)
Step.create(order: 3, description: 'remove old cabinet', task_id: 1)
Step.create(order: 4, description: 'install new cabinet, sink', task_id: 1)
Step.create(order: 5, description: 're-attach fittings and leak test', task_id: 1)

Step.create(order: 1, description: 'best_vaca.com', task_id: 2)
Step.create(order: 2, description: 'space_adventures_today.com', task_id: 2)
Step.create(order: 3, description: 'secret_getaways.com', task_id: 2)

Step.create(order: 1, description: 'hand mow terraces', task_id: 3)
Step.create(order: 2, description: 'edge walkway terraces', task_id: 3)
Step.create(order: 3, description: 'bush hog front 20', task_id: 3)
Step.create(order: 4, description: 'zero turn mow front & back', task_id: 3)

