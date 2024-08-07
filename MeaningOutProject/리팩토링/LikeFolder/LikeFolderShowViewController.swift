//
//  LikeFolderViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/8/24.
//

import UIKit
import SnapKit

class LikeFolderShowViewController: BaseViewController {
    let folderTable = UITableView()
    let folder = LikeRepository.shard.getFolderList()
    var navTitle: String?
    
    let vm = LikeFolderShowViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.inputViewDidLoad.value = ()
    }
    override func setUpHierarchy() {
        view.addSubview(folderTable)
    }
    override func setUpLayout() {
        folderTable.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func bindData() {
        vm.outputGetFolderList.bind { [weak self] _ in
            guard let self else { return }
            self.folderTable.reloadData()
        }
    }
    override func setUpView() {
        folderTable.delegate = self
        folderTable.dataSource = self
        folderTable.register(LikeFolderShowTableViewCell.self, forCellReuseIdentifier: LikeFolderShowTableViewCell.id)
        folderTable.rowHeight = 120
        
        navigationItem.title = navTitle
        let item = UIBarButtonItem(image: UIImage(systemName: "plus"),style: .plain,  target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = item
     
    }
    @objc func plusButtonTapped() {
        let vc = AddFolderViewController()
        vc.completion = {
            self.folderTable.reloadData()
        }
        let nv = UINavigationController(rootViewController: vc)
        present(nv, animated: true)
    }
}

extension LikeFolderShowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.outputGetFolderList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeFolderShowTableViewCell.id, for: indexPath) as! LikeFolderShowTableViewCell
        let data = vm.outputGetFolderList.value[indexPath.row]
        cell.changView(data)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LikeItemShowViewController()
        vc.index = indexPath.row
        vc.nvTitle = folder[indexPath.row].folderName
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
