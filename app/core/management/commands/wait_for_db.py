"""
Django command to wait for the db to be available
"""
import time 
from psycopg2 import OperationalError as Psycopg2Error
from django.db.utils import OperationalError 
from django.core.management.base import BaseCommand

class Command(BaseCommand):
    """Django command to wait for db"""
    def handle(self, *args, **options):
        """Entrypoint for command"""
        self.stdout.write("Waiting for database.....")# So this stdout is the standard output that we can use to log things to the screen as our command is executed. So 
        # this just shows in our console the message waiting for database
        db_up=False     #It is boolean value used to track of if our db is up yet
        while db_up is False:
            try:
                self.check(databases=['default'])
                db_up=True

            except (Psycopg2Error, OperationalError):
                self.stdout.write('Database Unavailable, waiting for 1 second.....')
                time.sleep(1)

                

        self.stdout.write(self.style.SUCCESS('Database available!'))