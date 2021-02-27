//
//  ViewController.swift
//  ImageSearch
//
//  Created by prashant thakare on 22/02/21.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate {
    
    
    var result:[Result] = []
    let searchBar = UISearchBar()
    let alert = UIAlertController(title: "Error", message: "Check Your Internet Connection", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Error", style: .default, handler: nil)
    
    
    private var collectionView:UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(alertAction)
        
        searchBar.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (view.frame.size.width)/2, height: (view.frame.size.height)/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView = collectionView
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //fetchData(Query: text)
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
        
        
       
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            result = []
            collectionView?.reloadData()
            fetchData(Query: text)
        }
        else{
            
        }
    }
    
    func fetchData(Query:String){
        let urlString = "https://api.unsplash.com/search/photos?page=1&query=\(Query)&client_id=WuBEAXzCr0cnJ1hAgugDx1R5ITlvME5YaxgLc-wrUFE"
        
        guard let url = URL(string: urlString)else{
            return
        }
        let task = URLSession.shared
        
        task.dataTask(with: url) { [self] (data, resp, error) in
            if let data = data{
                
            
                do{
                    let jsonResult = try JSONDecoder().decode(ApiResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.result = jsonResult.results
                        self.collectionView?.reloadData()
                    }
                    
                    
                    
                }
                catch{
                    print(error.localizedDescription)
                    
                }
            
                
                
                
                
        }
            else{
                DispatchQueue.main.async {
                    
                    self.present(alert, animated: true, completion: nil)
                    self.collectionView?.isHidden = true
                    
                }
                
                
                
            }
       
        
        
        }.resume()


}
}
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrlString = result[indexPath.row].urls.thumb
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        cell.config(with: imageUrlString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: view.frame.size.width/2, height:view.frame.size.height/4)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        print("hrhhhrhrhrh")
         let imgUrl = result[indexPath.row].urls.regular
        
        let vc = storyboard?.instantiateViewController(identifier: "ImageViewController") as! ImageViewController
        vc.config(with: imgUrl)
        
       self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
    
    
}

