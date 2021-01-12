//
//  HomeViewController.swift
//  PlatziTweets
//
//  Created by Jose Octavio on 15/08/20.
//  Copyright © 2020 Jose Octavio. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import AVKit

class HomeViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //    MARK: - Properties
    private let cellId = "TweetTableViewCell"
    private var dataSource = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
        // getPosts()
        SVProgressHUD.dismiss()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPosts()
        
    }
    private func setupUI(){
        //        1.Asignar datasource
        //        2. registrar celda
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func getPosts() {
        //Indicar carga al usuario
        SVProgressHUD.show()
        //2. Consumir serviio
        SN.get(endpoint: Endpoints.getPosts) { (response: SNResultWithEntity<[Post], ErrorResponse >) in
            
            //            Cerramos el indicador de carga
            SVProgressHUD.dismiss()
            
            
            switch response {
            case .success(let posts):
                self.dataSource = posts
                self.tableView.reloadData()
            case .error(let error):
                
                // todo lo malo :(
                NotificationBanner(subtitle: "Error", style: .danger).show()
                
            case .errorResult(let entity):
                
                // error pero no tan malo :)
                NotificationBanner(subtitle: "Error jeje", style: .warning).show()
            }
        }
    }
    
    private func deletePostAt(indexPath: IndexPath) {
        //       1. Indicar carga al usuario
        SVProgressHUD.show()
        
        //        2. Obtener el ID del post que vamos a borrar
        let postId = dataSource[indexPath.row].id
        
        //        3. Con  esto preparamos el endpoint para borrar
        let endpoint = Endpoints.delete + postId
        
        //     4. Consumir el servicio
        SN.delete(endpoint: endpoint) { (response: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
            //            Cerramos el indicador de carga
            SVProgressHUD.dismiss()
            
            
            switch response {
            case .success:
//                1 Borrar el post del Datasource
                 self.dataSource.remove(at: indexPath.row)
                
//                2 Borrar la celda de la tabla
                 self.tableView.deleteRows(at: [indexPath], with: .bottom)
                
                
            case .error(let error):
                
                // todo lo malo :(
                NotificationBanner(subtitle: "Error", style: .danger).show()
                
            case .errorResult(let entity):
                
                // error pero no tan malo :)
                NotificationBanner(title: "Error", subtitle: "You cannot delete other peolpe's posts", style: .warning).show()
            }
        }
        
    }
    
}
// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            //            Aqui Borramos el tweet
            self.deletePostAt(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        Guardar el correo del usuario y validar contra uno real
        return dataSource[indexPath.row].author.email == UserDefaults.standard.string(forKey: "email-key")
    }
}
// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    //    Numero total de celdas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    //    Configurar cwelda deseada
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? TweetTableViewCell {
            //            configurar la celda
            
            cell.setupCellWith(post: dataSource[indexPath.row])
            cell.needsToShowVideo = { url in
                //Aqui si deberiamos abrir un viewcontroller
                
                let avPlayer = AVPlayer(url: url)
                let avPlayerController = AVPlayerViewController()
                avPlayerController.player = avPlayer
                
                self.present(avPlayerController, animated:  true) {
                    avPlayerController.player?.play()
                }
            }
        }
        return cell
    }
}
//MARK: - Navigation

extension HomeViewController {
    
//    Este método se llamará cuando hagamos transiciones entre pantallas (solo con storyboards)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        1. Validar que els egue sea el esperado
        if segue.identifier == "showMap" , let mapViewController = segue.destination as? MapViewController{
//            Ya sabemos que si vamos a la pantalla del mapa
            mapViewController.posts = dataSource.filter { $0.hasLocation }
        }
    }
}
