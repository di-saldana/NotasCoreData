//
//  ListaNotasController.swift
//  NotasCoreData
//
//  Created by Dianelys Saldaña on 2/2/24.
//

import UIKit
import CoreData

class ListaNotasController: UITableViewController, UISearchResultsUpdating {
    var listaNotas : [Nota]!
    
    let searchController = UISearchController(searchResultsController: nil)
    let throttler = Throttler(minimumDelay: 0.5)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.listaNotas = []
        //ListaNotasController recibirá lo que se está escribiendo en la barra de búsqueda
        searchController.searchResultsUpdater = self
        //Configuramos el search controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar texto"
        //Lo añadimos a la tabla
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaNotas.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let request: NSFetchRequest<Nota> = Nota.fetchRequest()
        
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let miContexto = miDelegate.persistentContainer.viewContext
        
        do {
            listaNotas = try miContexto.fetch(request)
            self.tableView.reloadData()
        } catch {
            print("Error al recuperar las notas: \(error)")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miCelda", for: indexPath)

        cell.textLabel?.text = self.listaNotas[indexPath.row].contenido
        
        if let libreta = self.listaNotas[indexPath.row].libreta {
            cell.detailTextLabel?.text = "Libreta: \(libreta.nombre ?? "Sin nombre")"
        } else {
            cell.detailTextLabel?.text = "Sin libreta"
        }


        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
        throttler.throttle {
            let texto = searchController.searchBar.text!
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<Nota> = Nota.fetchRequest()
            
            if !texto.isEmpty {
                fetchRequest.predicate = NSPredicate(format: "texto CONTAINS[cd] %@", texto)
            }
            
            let dateSortDescriptor = NSSortDescriptor(key: "fecha", ascending: false)
            fetchRequest.sortDescriptors = [dateSortDescriptor]
            
            do {
                self.listaNotas = try context.fetch(fetchRequest)
                self.tableView.reloadData()
            } catch {
                print("Error al recuperar las notas: \(error)")
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


