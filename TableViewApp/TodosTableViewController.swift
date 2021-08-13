//
//  TodosTableViewController.swift
//  TableViewApp
//
//  Created by 김모경 on 2021/07/16.
//

import UIKit
import UserNotifications

class TodosTableViewController: UITableViewController {

    // MARK: - Properties
    // MARK: Privates
    /// todo 목록 - dummy 데이터
    /*
    private var todos: [Todo] = [Todo(title: "테스트1", due: Date(), memo: "메모1", shouldNotify: true, id: "1"),
                                 Todo(title: "테스트2", due: Date(), memo: "메모2", shouldNotify: true, id: "2"),
                                 Todo(title: "테스트3", due: Date(), memo: "메모3", shouldNotify: true, id: "3")]*/
    /// todo 목록 
    private var todos: [Todo] = Todo.all
    

    /// 셀에 표시할 날짜를 포멧하기 위한 Date Formatter
    /// (Date 타입의 데이터를 String 타입으로 변환해주던지, 아니면 그 역을 수행하는 클래스)
    private let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIViewController에서 제공하는 기본 수정버튼
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 화면이 보여질 때마다 todo 목록을 새로고침
        self.todos = Todo.all
        self.tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.automatic)
    }
    

    ///테이블뷰에 데이터를 전달해줄 테이블뷰 데이터 소스 메서드
    ///테이블뷰 -> 테이블뷰 delegate + 테이블뷰 데이터 소스. 2친구의 도움을 받음
    
    // MARK: - Table view data source

    ///테이블 뷰의 섹션 수 반환 (기본값 1)
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    /// 테이블 뷰의 섹션 별 로우 수 반환
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.todos.count
        //return 30
    }

    /// 인덱스에 해당하는 cell 반환
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        /// 스토리보드에 구현해 둔 셀을 재사용 큐에서 꺼내옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        ///let cell = UITableViewCell()

        guard indexPath.row < self.todos.count else { return cell }
        
        let todo: Todo = self.todos[indexPath.row]
        
        /// cell에 내용 설정
        cell.textLabel?.text = todo.title
        cell.detailTextLabel?.text = self.dateFormatter.string(from: todo.due)
        
        
        if indexPath.row == 5 {
            cell.backgroundColor = .lightGray
        }
        else {
            cell.backgroundColor = .systemBackground
        }

        return cell
    }
    
    
    //셀 삭제하기
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                ///todos.remove(at: indexPath.row)
                ///tableView.deleteRows(at: [indexPath], with: .fade)
                todos.remove(at: indexPath.row) //Remove element from your array
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else if editingStyle == .insert {
                
            }
        }
    
    
    ///목록 순서 바꾸기
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = todos[(sourceIndexPath as NSIndexPath).row]
            todos.remove(at: (sourceIndexPath as NSIndexPath).row)
            todos.insert(itemToMove, at: (destinationIndexPath as NSIndexPath).row)
        }
    

    
    // MARK: - Navigation

    ///스토리보드에서 세그를 2개 만들어줬음. 세그를 작동시킬 녀석이 테이블뷰셀, 바버튼 아이템 + 버튼 아이템, 2가지가 있었음
    ///+버튼을 누를 때는, 새 할일을 만드는 과정이었기 때문에, 테이블뷰의 목록에 있는 할일 데이터를 넘길 필요가 없었음
    ///그렇지만 셀을 선택햇을 때 작동한다면, sender를 통해서 셀. 참조가 넘어올 것임
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let todoViewController: TodoViewController = segue.destination as? TodoViewController else {
            return
        }
        
        guard let cell: UITableViewCell = sender as? UITableViewCell else { return }
        guard let index: IndexPath = self.tableView.indexPath(for: cell) else { return }
        ///그리고 그 셀의 인덱스를 통해서 할일 데이터가 어떤 인덱스에 있는 데이터를 넘기면 될지 찾아낸 다음에
        
        guard index.row < todos.count else { return }
        let todo: Todo = todos[index.row]
        todoViewController.todo = todo
        ///그 할일 데이터를 투두뷰컨트롤러의 인스턴스에게 넘겨줌
    }
    
}

/// User Notification의 delegate 메서드 구현
/// (테이블뷰 컨트롤러를 extension을 사용해서 UNUserNotificationCenterDelegate 프로토콜을 채택한 다음에
/// 거기다가 프로토콜 메서드를 구현해줌
/// => 이 테이블뷰컨트롤러의 인스턴스가 노티피케이션 딜리게이트 역할을 할 것임)
extension TodosTableViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let idToShow: String = response.notification.request.identifier
        
        guard let todoToShow: Todo = self.todos.filter({ (todo: Todo) -> Bool in
            return todo.id == idToShow
        }).first else {
            return
        }
        
        guard let todoViewController: TodoViewController = self.storyboard?.instantiateViewController(withIdentifier: TodoViewController.storyboardID) as? TodoViewController else { return }
        
        todoViewController.todo = todoToShow
        
        self.navigationController?.pushViewController(todoViewController, animated: true)
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        completionHandler()
    }
}
