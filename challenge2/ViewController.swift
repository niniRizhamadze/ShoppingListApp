
import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareViaEmail))
        
        let whiteSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let clearList = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearShoppingList))
        
        toolbarItems = [whiteSpace,clearList]
        navigationController?.isToolbarHidden = false
        
        getList()
    }
    
    @objc func shareViaEmail(){
        let share =  UIActivityViewController(activityItems: [shoppingList.joined(separator: "\n")], applicationActivities: [])
        present(share, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    
    @objc func addItem(){
        let ac = UIAlertController(title: "Add an item in your list...", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let addAction = UIAlertAction(title: "Add", style: .default){[weak self]_ in
            if let item = ac.textFields?[0].text{
               
                self?.shoppingList.insert(item, at: 0)
                
                let indexPath = IndexPath(row: 0, section: 0)
                
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
                
                self?.saveList()
            }
          
        }
        ac.addAction(addAction)
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Delete Item", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Go back", style: .cancel))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] action in
            self?.deleteItem(at: indexPath.row)
        }))
        present(ac, animated: true)
    }
    
    @objc func clearShoppingList(){
        let ac = UIAlertController(title: "Clear shoppingList", message: "Are you sure?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Yes", style: .default){[weak self]_ in
            self?.shoppingList.removeAll(keepingCapacity: true)
            self?.saveList()
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Go back", style: .default))
        present(ac, animated: true)
    }
    
    func deleteItem(at location: Int){
        shoppingList.remove(at: location)
        saveList()
        let indexPath = IndexPath(row: location, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func saveList(){
        let defaults = UserDefaults.standard
        defaults.set(shoppingList, forKey: "shoppingList")
    }
    
    func getList(){
        let defaults = UserDefaults.standard
        if let list = defaults.object(forKey: "shoppingList") as? [String]{
            shoppingList = list
        }
    }

}
