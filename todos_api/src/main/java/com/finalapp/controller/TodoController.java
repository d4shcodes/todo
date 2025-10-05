package com.finalapp.controller;

import com.finalapp.model.Todo;
import com.finalapp.model.User;
import com.finalapp.repository.TodoRepository;
import com.finalapp.repository.UserRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/todos")
public class TodoController {

    private final TodoRepository todoRepo;
    private final UserRepository userRepo;

    public TodoController(TodoRepository todoRepo, UserRepository userRepo) {
        this.todoRepo = todoRepo;
        this.userRepo = userRepo;
    }

    // @GetMapping
    // public List<Todo> getAll() {
    //     return todoRepo.findAll();
    // }

    @GetMapping("/user/{userId}")
    public List<Todo> getByUser(@PathVariable Long userId) {
        User user = userRepo.findById(userId).orElseThrow();
        return todoRepo.findByUserOrderByCompletedAsc(user);
    }

    @PostMapping("/user/{userId}")
    public Todo create(@PathVariable Long userId, @RequestBody Todo todo) {
        User user = userRepo.findById(userId).orElseThrow();
        todo.setUser(user);
        return todoRepo.save(todo);
    }

    // @PutMapping("/{id}")
    // public Todo update(@PathVariable Long id, @RequestBody Todo todoDetails) {
    //     Todo todo = todoRepo.findById(id).orElseThrow();
    //     todo.setTitle(todoDetails.getTitle());
    //     todo.setDescription(todoDetails.getDescription());
    //     todo.setCompleted(todoDetails.getCompleted());
    //     // todo.setDueDate(todoDetails.getDueDate());
    //     return todoRepo.save(todo);
    // }

    @PutMapping("/{id}/status")
    public Todo updateStatus(@PathVariable Long id, @RequestBody Boolean completed) {
        Todo todo = todoRepo.findById(id).orElseThrow();
        todo.setCompleted(completed);
        return todoRepo.save(todo);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        todoRepo.deleteById(id);
    }
}
