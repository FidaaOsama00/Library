#!/bin/bash

# Constants
BOOKS_FILE="books.txt"
BORROW_FILE="borrow.txt"

# Functions
search_books() {
echo "   "
echo -n "Enter the book title: "
read book_title
if [ "$book_title" = "done" ]; then
return
fi

grep -i "Title: $book_title" $BOOKS_FILE
if [ $? -ne 0 ]; then
echo "Book not found. Please try again."
search_books
fi
}

buy_books() {
echo "   "
total_price=0
echo "Enter the book titles you want to buy (Type 'done' when you are finished):"
while true; do
echo -n "Book title: "
read book_title
if [ "$book_title" = "done" ]; then

break
fi

book_info=$(grep -i "Title: $book_title" $BOOKS_FILE)
if [ -z "$book_info" ]; then
echo "Book '$book_title' not found. Please try again."
continue
fi

price=$(echo $book_info | sed -E 's/.*Price: ([0-9.]+).*/\1/')
echo "Price: $price"
total_price=$((total_price + $(printf $price)))
done

echo "Total price: $total_price"
}

borrow_book() {
echo "   "
echo -n "Enter the book title you want to borrow: "
read book_title

book_info=$(grep -i "Title: $book_title" $BOOKS_FILE)

if [ -z "$book_info" ]; then
echo "Book '$book_title' not found. Please try again."
borrow_book
else
echo "$book_info" >> $BORROW_FILE
echo "Do you want to add another book? (yes/no)"
read answer
if [ "$answer" = "yes" ]; then
borrow_book
else
echo "Operation accomplished successfully."
fi
fi
}

return_book() {
echo "   "
echo -n "Enter the book title you want to return: "
read book_title

book_info=$(grep -i "Title: $book_title" $BORROW_FILE)
if [ -z "$book_info" ]; then
echo "Book '$book_title' not found in the borrowed list. Please try again."
return_book
else
sed -i "/$book_info/d" $BORROW_FILE
echo "Operation accomplished successfully."
fi
}

# Reader
display_reader_menu() {
echo "   "
echo "Choose an operation"
echo "a. Search"
echo "b. Buy book"
echo "c. Borrow book"
echo "d. Return book"
echo "e. Exit"
echo -n "Enter your choice: "
read reader_choice
case $reader_choice in
a)
search_books
;;
b)
buy_books
;;
c)
borrow_book
;;
d)
return_book
;;
e)
exit
;;
*)
echo "Invalid choice. Try again..."
;;
esac
}


# Main program
echo "1. Reader"
echo "2. Library Staff"
echo -n "Enter your choice: "
read choice
case $choice in 

1) 
display_reader_menu
;;

# Library Staff
2)
echo "Here will be the code for the library staff."
;;
*)
echo "Invalid choice. Exiting..."
exit
;;
esac
