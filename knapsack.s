/*

unsigned int max(unsigned int a, unsigned int b){
  //computes the max of a and b
  return a > b ? a : b;
}

{
  unsigned int i;
  unsigned int best_value = cur_value;
  

    if(capacity - weights[i] >= 0 ){//if we can fit this item into our pack
      //see if it will give us a better combination of items
    
    }//if we can fit this item into our pack   
  }//try to find the best combination of items among the remaining items
  return best_value;


	
}//knapsack
	*/

	.global knapsack
	//unsigned int knapsack(int* weights, unsigned int* values, unsigned int num_items, int capacity, unsigned int cur_value)
	.equ wordsize, 4

knapsack:

	push %ebp
	movl %esp, %ebp
	subl $2*wordsize, %esp

	.equ weights, 2*wordsize
	.equ values, 3*wordsize
	.equ num_items, 4*wordsize
	.equ capacity, 5*wordsize
	.equ cur_value, 6*wordsize
	.equ i, -1*wordsize
	.equ best_value, -2*wordsize

	push %ebx
        push %esi
	push %edi
	//	  for(i = 0; i < num_items; i++){//for each remaining item
	movl $0, %ecx
	movl cur_value(%ebp), %edx
	movl %edx, best_value(%ebp)
num_loop:
	cmpl num_items(%ebp), %ecx
	jge end_num_loop
	movl weights(%ebp), %edx
	movl (%edx, %ecx, wordsize), %edx
	cmpl %edx, capacity(%ebp)
	jl else
	//	  best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, capacity - weights[i], cur_value + values[i]));
        movl weights(%ebp), %edx
	movl (%edx, %ecx, wordsize), %edx
	movl capacity(%ebp), %edi
	subl %edx, %edi #edi = capacity - weights[i]
	movl weights(%ebp), %edx
	leal (%edx, %ecx, wordsize), %edx
	addl $4, %edx #edx = weights + i + 1
	movl values(%ebp), %ebx
	movl (%ebx, %ecx, wordsize), %ebx
	movl cur_value(%ebp), %eax
	addl %ebx, %eax #eax = cur_value + values[i]
	movl values(%ebp), %ebx
	leal (%ebx, %ecx, wordsize), %ebx
	addl $4, %ebx #ebx = values + i + 1
	movl num_items(%ebp), %esi
	subl %ecx, %esi
	decl %esi #esi = num_items - i - 1
        movl %ecx, i(%ebp)


	//	  best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, capacity - weights[i], cur_value + values[i]));
	push %eax
	push %edi	
	push %esi
	push %ebx
	push %edx
	call knapsack

	addl $5*wordsize, %esp
	movl i(%ebp), %ecx
	movl best_value(%ebp), %edx
	cmpl %edx, %eax
	ja max_func	
	movl %edx, %eax
	jmp else
max_func:
	movl %eax, best_value(%ebp)
else:
	incl %ecx
	jmp num_loop
	
end_num_loop:	
	pop %edi
	pop %esi
	pop %ebx

	movl best_value(%ebp), %eax
	movl %ebp, %esp
	pop %ebp
	ret
	
