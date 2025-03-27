"use client";

import { useState } from "react";
import { api } from "~/trpc/react";

export function TodoList() {
  const [newTodo, setNewTodo] = useState("");
  const utils = api.useUtils();
  const { data: todos, isLoading } = api.todo.getAll.useQuery();
  const createTodo = api.todo.create.useMutation({
    onSuccess: () => {
      setNewTodo("");
      void utils.todo.getAll.invalidate();
    },
  });
  const deleteTodo = api.todo.delete.useMutation({
    onSuccess: () => {
      void utils.todo.getAll.invalidate();
    },
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (newTodo.trim()) {
      createTodo.mutate({ text: newTodo });
    }
  };

  if (isLoading) return <div>Loading...</div>;

  return (
    <div className="w-full max-w-md space-y-4">
      <form onSubmit={handleSubmit} className="flex gap-2">
        <input
          type="text"
          value={newTodo}
          onChange={(e) => setNewTodo(e.target.value)}
          placeholder="Add a new todo..."
          className="flex-1 rounded-lg bg-white/10 px-4 py-2 text-white placeholder:text-white/50"
        />
        <button
          type="submit"
          className="rounded-lg bg-white/10 px-4 py-2 font-semibold text-white hover:bg-white/20"
        >
          Add
        </button>
      </form>

      <div className="space-y-2">
        {todos?.map((todo) => (
          <div
            key={todo.id}
            className="flex items-center justify-between rounded-lg bg-white/10 p-4"
          >
            <span className="text-white">{todo.text}</span>
            <button
              onClick={() => deleteTodo.mutate({ id: todo.id })}
              className="rounded bg-red-500 px-3 py-1 text-sm text-white hover:bg-red-600"
            >
              Delete
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
